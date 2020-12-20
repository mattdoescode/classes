# def convert_range(min, max, newMin, newMax, oldValue):
#     oldRange = max - min
#     newRange = newMax - newMin
#     newValue = (((oldValue - min) * newRange) / oldRange) + newMin
#     return newValue

# print(convert_range(0,1, 1, 255, 0.6))


# from noise import pnoise2, snoise2
# print(pnoise3(0,2,0))

# import matplotlib.pyplot as plt
# from perlin_noise import PerlinNoise

# noise1 = PerlinNoise(octaves=3)
# noise2 = PerlinNoise(octaves=6)
# # noise3 = PerlinNoise(octaves=12)
# # noise4 = PerlinNoise(octaves=24)

# mine = PerlinNoise(1,1)

# print(mine.octaves)


# xpix, ypix = 10, 10
# pic = []
# collection = []
# for i in range(xpix):
#     row = []
#     for j in range(ypix):
#         noise_val =         noise1([i/xpix, j/ypix])
#         noise_val += 0.5  * noise2([i/xpix, j/ypix])
#         # noise_val += 0.25 * noise3([i/xpix, j/ypix])
#         # noise_val += 0.125* noise4([i/xpix, j/ypix])
#         row.append(noise_val)
#     pic.append(row)

# plt.imshow(pic, cmap='gray')
# plt.show()

# import pygame

# fonts = pygame.font.get_fonts()
# print(len(fonts))
# for f in fonts:
#     print(f)


a = [0,1,2,3,4]

outerCount = 0

for nodeouter in range(len(a[:-1])):
    outerCount = outerCount + 1
    for nodinner in range(len(a) - outerCount):
    
      print(a[nodeouter], + a[nodinner + outerCount])
