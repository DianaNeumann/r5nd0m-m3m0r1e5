import sys
import os
import math
from PIL import Image

IMAGE_WIDTH = 256 # Width of the final photo, in pixels



def main():
  if len(sys.argv) != 2:
    print('[-] Usage: python v1sualizati0n.py your_file')
    exit(1)

  input_file_name = sys.argv[1]
  input_file = open(input_file_name, 'rb')
  input_data = bytearray(input_file.read())
  
  if len(input_data) == 0:
    print("[-] File is empty.")
    return exit(1)

  image_size = (IMAGE_WIDTH, int(math.ceil(len(input_data) / (IMAGE_WIDTH * 1.0))))
  image = Image.new("RGB", image_size, "white")

  fill_image(input_data, image, image_size)
  image.convert("P").save(input_file_name + ".png", "PNG")


def fill_image(input_data, image, image_size):
  x_range = range(IMAGE_WIDTH)
  y_range = range(image_size[1])
  d_range = len(input_data)
  pixel = image.load()
  index = 0

  for y in y_range:
    for x in x_range:
      pixel[x,y] = convert_color(input_data[index])
      index += 1
      if index >= d_range:
        break

def convert_color(byte):
  if byte >= 0x80:
    return 0x000000
  elif byte > 0x20:
    return 0x0000ff
  elif byte >= 0x01:
    return 0xffff00
  else:
    return 0xffffff


if __name__ == "__main__":
  main()
