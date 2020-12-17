import pygame
import math
import random
class Node():

    BLACK = ( 0, 0, 0)
    WHITE = (255, 255, 255)
    GREEN = (0, 255, 0)
    RED = (255, 0, 0)

    # range, battery life, sleep settings, role, detected neighbors
    def __init__(self, name, position, id):
        self.location = position

        #range = radius of circle
        self.range = 125
        self.color = self.RED
        # batteryLife = 100
        # sleepSettings = 0
        self.role = name
        self.id = id
        # neightbors = 0
        # connected = False
        self.dectedColor = (255,0,0)
        print("making new:", self.role)

    def colorChange(self, color):
        self.color = color

    def show(self, screen, font, toggle):
        #TO DO: Range = to height of sensor on map
        size = self.range
            
        img = font.render(str(self.id) + " " + str(self.role[0]), True, self.color)
        screen.blit(img, (self.location[0]-30, self.location[1]-20))

        if toggle:
            pygame.draw.circle(screen, self.dectedColor, [self.location[0], self.location[1]], 5, 255)
            pygame.draw.circle(screen, self.color, [self.location[0], self.location[1]], self.range, 2)

class Network():
    # do this later
    def __init__():
        print("new")