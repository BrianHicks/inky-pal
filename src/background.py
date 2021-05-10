#!/usr/bin/env python
from PIL import Image

class Background:
    WIDTH = 400
    HEIGHT = 300

    def __init__(self, image):
        self.image = image

    @classmethod
    def open(cls, filename):
        return cls(Image.open(filename))

    def convert(self):
        self.resize()
        self.crop()
        self.dither()

    # resize an image so that it's longest dimension is somewhere in the
    # WIDTHxHEIGHT window, for further cropping down the line
    def resize(self):
        width, height = self.image.size

        if width > height:
            new_width = int(float(width) / height * self.HEIGHT)
            new_height = self.HEIGHT
        else:
            new_width = self.WIDTH
            new_height = int(float(height) / width * self.WIDTH)

        self.image = self.image.resize(
            (new_width, new_height),
            resample=Image.LANCZOS,
        )

    # crop an image to WIDTHxHEIGHT in the center of whatever space is available
    # in the image
    def crop(self):
        width, height = self.image.size

        # we want a center crop, so we need to start the crop half the difference
        # of the widths from the left edge, and half the difference of the
        # heights from the top edge
        left = abs(width - self.WIDTH) / 2
        top = abs(height - self.HEIGHT) / 2
        right = self.WIDTH + left
        bottom = self.HEIGHT + top # we already resized to the output height

        self.image = self.image.crop((left, top, right, bottom))

    def dither(self):
        # from https://github.com/pimoroni/inky/blob/75f12b415ad1ae42ac3be92b33f83f51519f5da3/examples/what/dither-image-what.py#L59
        palette = Image.new('P', (1, 1))
        palette.putpalette((255, 255, 255, 0, 0, 0, 255, 0, 0) + (0, 0, 0) * 252)

        self.image = self.image.convert("RGB").quantize(palette=palette)

    def show(self):
        self.image.show()

if __name__ == '__main__':
    from argparse import ArgumentParser

    parser = ArgumentParser(__file__)
    parser.add_argument('filename', help='source image for the converted background')
    args = parser.parse_args()

    background = Background.open(args.filename)
    background.convert()
    background.show()
