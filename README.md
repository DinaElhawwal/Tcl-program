# tcl
Main Program :
A Tcl program that starts with displaying a menu for the user to choose a specific action and
based on his/her action start to call the appropriate answer

Detailed Description
 1. Load File:
- a function that asks the user for the file name/path to load the file.
- If user entered a directory it prints a list with all pdb files in this directory.
- If user entered a file name it makes sure it exists and accessible (prints error
  message if not)
 
2. Select a residue 
- a function which asks the user for the residue name/range.
- Draws a box surrounding the selected atoms.
- Makes sure that user has already loaded a file
 
 3. Save Selection 
 - a function that saves a selection
 - Makes sure that user has already selected atoms before
 - Asks the user for a folder/path to save data in
 - Makes sure that the path exist (prints error message if not)
 - Makes sure user have access to save in the path (prints error message if not)
 - Asks user for file name
 - Saves the file as pdb

4. Analyze 
a function which prints all information for a selection
  ● Number of atoms
  ● Number of bonds
  ● Number of residues
  
5. Process Residues
- a function that gets all residues
- Prints number of atoms in each residue
- Draws each residue with different color
- Outputs formatted as in table 

6. Align molecules 
- Implements a function that do the following functions
- Makes sure that the openGL menu have no drawing (clears window)
- Asks user to enter 2 file names
- Loads files
- Moves the molecules to be aligned on top of each other

