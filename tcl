global check_load
set check_load 0
global check_select
set check_select 0
proc list_item {path} {
cd $path
global check_load
set contents [glob *.pdb]
foreach item $contents {
puts $item
}
}
proc load_file {} {
puts "Enter a path or folder :"
gets stdin path
set check_dir [file isdirectory $path]
set check_file [file isfile $path]
set check_exist [file exists $path]
global check_load

if {$check_dir==1} {
list_item $path }
if {$check_file==1} { 
  mol new $path 
  set check_load 1
  } elseif {$check_exist!=1} {

  puts "File doesnt exist"  
}
}
proc selection {} {
global check_load
global res
if { $check_load ==1} {
puts "Enter a resname to select"
gets stdin res
set sel [ atomselect top "resname $res" ]
global check_select
set check_select 1
set min_max [measure minmax $sel]

set min_coo [lindex $min_max 0]
set max_coo [lindex $min_max 1]

set max_x [lindex $max_coo 0]
set max_y [lindex $max_coo 1]
set max_z [lindex $max_coo 2]

set min_x [lindex $min_coo 0]
set min_y [lindex $min_coo 1]
set min_z [lindex $min_coo 2]

draw materials off 
draw color yellow
draw line "$min_x $min_y $min_z" "$max_x $min_y $min_z"
draw line "$min_x $min_y $min_z" "$min_x $max_y $min_z"
draw line "$min_x $max_y $min_z" "$max_x $max_y $min_z"
draw line "$max_x $min_y $min_z" "$max_x $max_y $min_z"

draw line "$min_x $min_y $max_z" "$max_x $min_y $max_z"
draw line "$min_x $min_y $max_z" "$min_x $max_y $max_z"
draw line "$max_x $max_y $max_z" "$min_x $max_y $max_z"
draw line "$max_x $max_y $max_z" "$max_x $min_y $max_z"

draw line "$min_x $min_y $min_z" "$min_x $min_y $max_z"
draw line "$min_x $max_y $min_z" "$min_x $max_y $max_z"
draw line "$max_x $min_y $min_z" "$max_x $min_y $max_z"
draw line "$max_x $max_y $max_z" "$max_x $max_y $min_z"


} else { puts "File not loaded"}
}
proc save_selection {} {
global check_select
global res
if { $check_select ==1} {
puts "Selected residue : $res"
set sel [ atomselect top "resname $res" ]
puts "Enter a path or folder :" 
gets stdin path 
set check_exist [file exists $path] 
if {$check_exist==1} { 
set check_access [file writable $path] 
if {$check_access==1} { 
puts "Enter a file name :" 
gets stdin file_name 
$sel writepdb $path$file_name.pdb
} else { 
 puts "File can't be accessed" 
} 
} else { 
 puts "File doesnt exist" 
}  
} else {
 puts "No selected residue"
}
} 
proc analyze {} {
gets stdin id
set Allatoms [atomselect $id all]
set Allresidues [lsort -unique [$Allatoms get residue]]
set number_atoms [$Allatoms num]
set number_residues [llength $Allresidues]
puts "Number of atoms:\t $number_atoms\nNumber of residues:\t$number_residues"
}

proc process_residue {} {
set Allatoms [atomselect top all]
set residue [lsort -unique [$Allatoms get resname]]
set Allresidue [lsort [$Allatoms get resname]]

for { set i 0} {$i<[llength $residue]} {incr i } {
set atom_num 0
set current_res [ atomselect top " resname [lindex $residue $i] "]
$current_res set beta [expr $i*10]
    for {set j 0} {$j < [$Allatoms num]} {incr j } {
     if {[lindex $Allresidue $j ] == [lindex $residue $i]} {
       incr atom_num  
       }          
}
puts "[lindex $residue $i]   $atom_num"
}
}
proc allignment {} { 
 mol delete all 
 puts "Enter first path :" 
 gets stdin path_1 
 mol new $path_1 
 set mol_1 [atomselect top all] 
 puts "Enter second path :" 
 gets stdin path_2 
 mol new $path_2 
 set mol_2 [atomselect top all] 
 set allign [measure fit $mol_1 $mol_2] 
 $mol_1 move $allign 
}
set menu "\nHello User, Choose your action with number from 1 to 7
1. Load File
2. Select a residue
3. Save Selection
4. Analyze
5. Process Residues
6. Align Molecules
7. Exit
"
set choice 0
while {$choice<7} {
puts $menu
gets stdin choice
if {$choice==1}  {
load_file
} elseif {$choice==2} {
selection
} elseif {$choice==3} {
save_selection
} elseif {$choice==4} {
analyze 
} elseif {$choice==5} {
process_residue
} elseif {$choice==6} {
allignment 
}  
}
