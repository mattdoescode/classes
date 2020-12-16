import pygame

class Node():

    BLACK = ( 0, 0, 0)
    WHITE = (255, 255, 255)
    GREEN = (0, 255, 0)
    RED = (255, 0, 0)

    # range, battery life, sleep settings, role, detected neighbors
    def __init__(self, name, position):
        self.location = position
        self.range = 195
        # batteryLife = 100
        # sleepSettings = 0
        self.role = name
        # neightbors = 0
        # connected = False
        print("making new:", self.role)

    def show(self, screen, font, toggle):
        #TO DO: Range = to height of sensor on map
        size = self.range
        if toggle:
            pygame.draw.ellipse(screen, (255, 0, 0), [self.location[0]-(size/2), self.location[1]-(size/2), size, size], 2)
        img = font.render(self.role[0], True, Node.RED)
        screen.blit(img, (self.location[0]-10, self.location[1]-20))
        #arial
    


class Network():
    # do this later
    def __init__():
        print("new")