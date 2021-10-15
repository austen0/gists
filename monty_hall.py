import random
import sys
import time


def random_door(val):
  random.seed(time.time())
  return random.randint(1, val)

def set_prize():
  doors = {
    'door1': False,
    'door2': False,
    'door3': False,
  }

  # Put prize behind random door.
  prize = random_door(3)
  doors['door%d' % prize] = True
  return doors

def remove_door(choice, doors):
  no_prize = []

  # Exclude chosen door from removal options.
  doors_rm = dict(doors)
  doors_rm.pop(choice)

  # Exclude door with prize from removal options.
  for key, val in doors_rm.iteritems():
    if not val:
      no_prize.append(key)

  # Choose door to remove from remaining options.
  rm_door = no_prize[random_door(len(no_prize)) - 1]

  # Return new set of doors (one removed).
  doors.pop(rm_door)
  return doors

def simulate(switch, loops):
  win = 0
  i = 0
  while i < loops:
    doors = set_prize()
    # Make random contestant choice.
    choice = 'door%d' % random_door(len(doors))

    # Switch doors.
    if switch:
      new_doors = remove_door(choice, doors)
      # Check for win.
      for key, val in new_doors.iteritems():
        if key != choice:
          result = val
      if result:
        win += 1

    # Stay with same door.
    if not switch:
      new_doors = remove_door(choice, doors)
      result = new_doors[choice]  # Check for win.
      if result:
        win += 1

    i += 1

  # Return win ratio.
  return float(win) / loops

def main():
  # Simulate both cases 10k times and find win ratio.
  print 'Switch win ratio:  %.2f' % simulate(True, 10000)
  print 'Stay win ratio:    %.2f' % simulate(False, 10000)

if __name__ == '__main__':
  main()
