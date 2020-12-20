from opensimplex import OpenSimplex 
import pygame
import numpy

def convert_range(min, max, newMin, newMax, oldValue):
    oldRange = max - min
    newRange = newMax - newMin
    newValue = (((oldValue - min) * newRange) / oldRange) + newMin
    return newValue


tmp = OpenSimplex()

CONSTmapSize = 700,700
themap = numpy.zeros((CONSTmapSize[0], CONSTmapSize[1]))

for x in range(CONSTmapSize[0]):
    for y in range(CONSTmapSize[0]):
        nx = x/CONSTmapSize[0] - 0.5 
        ny = y/CONSTmapSize[1] - 0.5

        frequency = 5

        nx = nx * frequency
        ny = ny * frequency
        
        finalout = tmp.noise2d(nx,ny)

        themap[x][y] = convert_range(0,2,0,255, tmp.noise2d(nx,ny) + 1)
        #print(themap[x][y])

pygame.init()

screen = pygame.display.set_mode([CONSTmapSize[0], CONSTmapSize[1]])

running = True
paused = False


#display everything 
#keep state and track
while running:
    while not paused:
        # Did the user click the window close button?
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        # Fill the background with white
        for x in range(CONSTmapSize[0]):
            for y in range(CONSTmapSize[0]):
                screen.set_at((x, y), (themap[x][y],themap[x][y],themap[x][y]))

        # Flip the display
        pygame.display.flip()

# Done! Time to quit.
pygame.quit()