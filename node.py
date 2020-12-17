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

        self.range = 125
        self.color = self.RED
        # batteryLife = 100
        # sleepSettings = 0
        self.role = name
        self.id = id
        self.dectedColor = (255,0,0)
        self.isTounching = []

        print("making new:", self.role)
    def colorChange(self, color):
        self.color = color


    def sendTouching(self):
        return self.isTounching

    def show(self, screen, font, toggle):
        #TO DO: Range = to height of sensor on map
        size = self.range
            
        img = font.render(str(self.id) + " " + str(self.role[0]), True, self.color)
        screen.blit(img, (self.location[0]-30, self.location[1]-20))

        pygame.draw.circle(screen, self.dectedColor, [self.location[0], self.location[1]], 5, 255)
        if toggle:
            pygame.draw.circle(screen, self.color, [self.location[0], self.location[1]], self.range, 2)
    
    def drawConnection(self, connection, surface, color):
        pygame.draw.line(surface, color, self.location, connection.location, 5)

class Network():
    # do this later
    def __init__():
        print("new")