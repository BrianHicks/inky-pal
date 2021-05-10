#!/usr/bin/env python3
from inky import InkyWHAT
from PIL import Image

class Display:
    DEFAULT_MODE = 'red'

    def __init__(self, image, mode=DEFAULT_MODE):
        self.what = InkyWHAT(mode)
        self.what.set_image(image)

    @classmethod
    def open(cls, path, mode=DEFAULT_MODE):
        return cls(Image.open(path), mode=mode)

    def show(self):
        self.what.show()


if __name__ == '__main__':
    from argparse import ArgumentParser

    parser = ArgumentParser(__file__)
    parser.add_argument(
        'filename',
        help='a 300x400 image suitable for sending to the wHAT',
    )
    parser.add_argument(
        '--mode',
        default=Display.DEFAULT_MODE,
        choices=['red', 'black'],
        help='whether to load the image in b+w+red or b+w mode'
    )
    args = parser.parse_args()

    display = Display.open(args.filename, args.mode)
    display.show()
