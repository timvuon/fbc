/*
 *  libgfx2 - FreeBASIC's alternative gfx library
 *	Copyright (C) 2005 Angelo Mottola (a.mottola@libero.it)
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

/*
 * paint.c -- PAINT statement
 *
 * chng: jan/2005 written [lillo]
 *
 */

#include "fb_gfx.h"


typedef struct SPAN
{
	int y, x1, x2;
	struct SPAN *row_next;
	struct SPAN *next;
} SPAN;


/*:::::*/
static SPAN *add_span(FB_GFXCTX *context, SPAN **span, int *x, int y, unsigned int border_color)
{
	SPAN *s;
	int x1, x2;

	x1 = x2 = *x;
	while ((x1 > context->view_x) && (context->get_pixel(context, x1 - 1, y) != border_color))
		x1--;
	while ((x2 < context->view_x + context->view_w - 1) && (context->get_pixel(context, x2 + 1, y) != border_color))
		x2++;
	*x = x2 + 1;
	for (s = span[y]; s; s = s->row_next) {
		if ((x1 == s->x1) && (x2 == s->x2))
			return NULL;
	}
	s = (SPAN *)malloc(sizeof(SPAN));
	s->x1 = x1;
	s->x2 = x2;
	s->y = y;
	s->next = NULL;
	s->row_next = span[y];
	span[y] = s;

	return s;
}


/*:::::*/
FBCALL void fb_GfxPaint(void *target, float fx, float fy, unsigned int color, unsigned int border_color, FBSTRING *pattern, int mode, int flags)
{
	FB_GFXCTX *context = fb_hGetContext();
	int size, x, y;
	unsigned char data[256], *dest, *src;
	SPAN **span, *s, *tail, *head;

	if (!__fb_gfx)
		return;

	if (flags & DEFAULT_COLOR_1)
		color = context->fg_color;
	else
		color = fb_hFixColor(color);
	if (flags & DEFAULT_COLOR_2)
		border_color = color;
	else
		border_color = fb_hFixColor(border_color);

	fb_hPrepareTarget(context, target, color);

	fb_hFixRelative(context, flags, &fx, &fy, NULL, NULL);

	fb_hTranslateCoord(context, fx, fy, &x, &y);

	fb_hMemSet(data, 0, sizeof(data));
	if ((mode == PAINT_TYPE_PATTERN) && (pattern)) {
		fb_hMemCpy(data, pattern->data, MIN(256, FB_STRSIZE(pattern)));
    }
    if (pattern) {
        /* del if temp */
        fb_hStrDelTemp( pattern );
    }

	if ((x < context->view_x) || (x >= context->view_x + context->view_w) ||
	    (y < context->view_y) || (y >= context->view_y + context->view_h))
		return;

	if (context->get_pixel(context, x, y) == border_color)
		return;

	size = sizeof(SPAN *) * (context->view_y + context->view_h);
	span = (SPAN **)malloc(size);
	fb_hMemSet(span, 0, size);

	tail = head = add_span(context, span, &x, y, border_color);

	/* Find all spans to paint */
	while (tail) {
		if (tail->y - 1 >= context->view_y) {
			for (x = tail->x1; x <= tail->x2; x++) {
				if (context->get_pixel(context, x, tail->y - 1) != border_color) {
					s = add_span(context, span, &x, tail->y - 1, border_color);
					if (s) {
						head->next = s;
						head = s;
					}
				}
			}
		}
		if (tail->y + 1 < context->view_y + context->view_h) {
			for (x = tail->x1; x <= tail->x2; x++) {
				if (context->get_pixel(context, x, tail->y + 1) != border_color) {
					s = add_span(context, span, &x, tail->y + 1, border_color);
					if (s) {
						head->next = s;
						head = s;
					}
				}
			}
		}
		tail = tail->next;
	}

	DRIVER_LOCK();

	/* Fill spans */
	for (y = context->view_y; y < context->view_y + context->view_h; y++) {
		for (s = tail = span[y]; s; s = s->row_next, free(tail), tail = s) {

			dest = context->line[s->y] + (s->x1 * __fb_gfx->bpp);

			if (mode == PAINT_TYPE_FILL)
				context->pixel_set(dest, color, s->x2 - s->x1 + 1);
			else {
				src = data + (((s->y & 0x7) << 3) * __fb_gfx->bpp);
				if (s->x1 & 0x7) {
					if ((s->x1 & ~0x7) == (s->x2 & ~0x7))
						size = s->x2 - s->x1 + 1;
					else
						size = 8 - (s->x1 & 0x7);
					fb_hPixelCpy(dest, src + ((s->x1 & 0x7) * __fb_gfx->bpp), size);
					dest += size * __fb_gfx->bpp;
				}
				s->x2++;
				for (x = (s->x1 + 7) >> 3; x < (s->x2 & ~0x7) >> 3; x++) {
					fb_hPixelCpy(dest, src, 8);
					dest += 8 * __fb_gfx->bpp;
				}
				if ((s->x2 & 0x7) && ((s->x1 & ~0x7) != (s->x2 & ~0x7)))
					fb_hPixelCpy(dest, src, s->x2 & 0x7);
			}

			if (__fb_gfx->framebuffer == context->line[0])
				__fb_gfx->dirty[context->view_y + y] = TRUE;
		}
	}
	free(span);

	DRIVER_UNLOCK();

}
