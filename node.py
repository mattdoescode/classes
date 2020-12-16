import pygame
import math

class Node():

    BLACK = ( 0, 0, 0)
    WHITE = (255, 255, 255)
    GREEN = (0, 255, 0)
    RED = (255, 0, 0)

    # range, battery life, sleep settings, role, detected neighbors
    def __init__(self, name, position):
        self.location = position

        #range = radius of circle
        self.range = 100
        self.color = self.RED
        # batteryLife = 100
        # sleepSettings = 0
        self.role = name
        # neightbors = 0
        # connected = False
        print("making new:", self.role)

    def colorChange(self, color):
        self.color = color

    def show(self, screen, font, toggle):
        #TO DO: Range = to height of sensor on map
        size = self.range
            
        img = font.render(self.role[0], True, self.color)
        screen.blit(img, (self.location[0]-10, self.location[1]-25))
        
        if toggle:
            pygame.draw.circle(screen, (0, 0, 0), [self.location[0], self.location[1]], 5, 255)
            pygame.draw.circle(screen, self.color, [self.location[0], self.location[1]], self.range, 2)

    def checkNeighbors(self, otherNodes):
        
        #check distance from "self" to all other nodes
        for node in otherNodes:
            dist = math.sqrt(((node.location[0] - self.location[0])**2) + ((node.location[0] - self.location[0])**2))
            if dist < self.range:
                print("print something is in range")

class Network():
    # do this later
    def __init__():
        print("new")