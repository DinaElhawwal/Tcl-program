#20198069_20198127_20208004
#C:\\Users\\maboe\\Desktop\\workspace\\1ubq1.pdb
#C:\\Users\\maboe\\Desktop\\workspace\\1fqy.pdb
#C:\\Users\\maboe\\Desktop\\workspace\\1rc2.pdb
#source "C:\\Users\\maboe\\Desktop\\assignment.tcl"


global check_load
set check_load 0
global check_select
set check_select 0

global file;

global set list {};
global lrange ;
global hrange ;
proc saveFile {} {
	global hrange 
	global lrange
	puts "Please Enter wanted path to save the file in";
	gets stdin newPath;
	if {[file exists $newPath ]} {
		if {[file writable $newPath]} {
			
			if {[catch {cd $newPath}] > 0} {
			puts "directory didn't change";
			} else {
			puts "Enter the file Name";
			gets stdin fileName;
			set crystal [atomselect top "protein and resid $lrange to $hrange"]
			$crystal writepdb "$fileName"
			}
			
		} else {
			puts "Sorry, You don't have access to files in this path.";
		}
	} else {
		puts "File Path doesn't exist!";
	}
	
}

proc fileLoad {filePath} {
    global loaded
	#needs improvment
	set flag 0;
	
	for {set i 0} { $i < [string length "$filePath"] } {incr i} {
		if {[string range $filePath $i $i] == "."} { 
			set flag 1;
			break;
		}
	}
	
	if { $flag == 0} {
		if {[file exists $filePath]} {
			cd $filePath;
			set contents [glob *.pdb]
			puts "Directory contents are:"
			foreach item $contents {
			puts $item;
		}
		} else {
			puts "Directory Not Found!";
		}
			
	} else {
		if {[file exists $filePath]} {
			mol new $filePath;
			puts "File loaded successfuly!"
			
		} else {
			puts "File Not Found!";
		}
	}
}
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

proc box_molecule {low high filePath} {
	global list
	global lrange
	global hrange 
	set lrange $low 
	set hrange $high 
	if {[string length $filePath] > 0} { 
	
	set fp [open $filePath r];
	set x_max -123432;  
	set x_min 123432;
	set y_max -123432;
	set y_min 123432;
	set z_max -123432;
	set z_min 123432;
	while {[gets $fp data] >= 0 } {
	
	if {[string range $data 22 25] >= $low && [string range $data 22 25] <= $high } {
		lappend  list $data
		set x [string range $data 30 37];
		set y [string range $data 38 45];
		set z [string range $data 46 53];
		if { $x < $x_min } {
		set x_min $x;
		}
		if { $x > $x_max } {
		set x_max $x;
		}
		if { $y < $y_min } {
		set y_min $y;
		}
		if { $y > $y_max } {
		set y_max $y;
		}
		if { $z < $z_min } {
		set z_min $z;
		}
		if { $z > $z_max } {
		set z_max $z;
		}
	}
	  
	}
	 
      graphics top line "$x_min $y_min $z_min" "$x_max $y_min $z_min" width 2 style solid
	  
      graphics top line "$x_min $y_min $z_min" "$x_min $y_max $z_min" width 2 style solid

      graphics top line "$x_min $y_min $z_min" "$x_min $y_min $z_max" width 2 style solid
	  
      graphics top line "$x_max $y_min $z_min" "$x_max $y_max $z_min" width 2 style solid
	     
      graphics top line "$x_max $y_min $z_min" "$x_max $y_min $z_max" width 2 style solid
     
      graphics top line "$x_min $y_max $z_min" "$x_max $y_max $z_min" width 2 style solid
	 
      graphics top line "$x_min $y_max $z_min" "$x_min $y_max $z_max" width 2 style solid

      graphics top line "$x_min $y_min $z_max" "$x_max $y_min $z_max" width 2 style solid
	    
      graphics top line "$x_min $y_min $z_max" "$x_min $y_max $z_max" width 2 style solid
      
      graphics top line "$x_max $y_max $z_max" "$x_max $y_max $z_min" width 2 style solid

      graphics top line "$x_max $y_max $z_max"  "$x_min $y_max $z_max" width 2 style solid
	 
      graphics top line "$x_max $y_max $z_max" "$x_max $y_min $z_max" width 2 style solid
	  } else {
	  puts "You didn't load a proper file!";
	  }
	  
	  
	  
	 
}

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

proc analyze {filePath} {
global list
	set fp [open $filePath r];
	set numOfRes 0;
	set numOfAtoms 0;
	set resID -1;
	while { [gets $fp data] >= 0 } {
		if { [string range $data 0 3] == "ATOM" } {
			incr numOfAtoms;
			if {$resID != [string range $data 22 25]} {
				set resID [string range $data 22 25];
				incr numOfRes;
			}
		};
}
	puts "Number of Atoms is:			$numOfAtoms";
	puts "Number of Residues is:		$numOfRes";
	close $fp;
}

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
proc process {filePath} {
	
	set fp [open $filePath r];
	set numOfAtoms 0
	set prevResName ""
	set resNames {}
	while { [gets $fp data] >= 0 } {
		if { [string range $data 0 3] == "ATOM" } {
				#set listt [linsert $listt $x [string range $data 17 19]]
				lappend resNames [string range $data 17 19];
				incr numOfAtoms
		};
};
	
	set sortedList [lsort $resNames];
	set finalList {};
	set prevRes [lindex $sortedList 0];
	set numOfRes 0;
	set x 0;
	set sel [atomselect top "resname $prevRes" ]
	
	foreach res $sortedList {
		if {$prevRes == $res} {
			$sel set beta $x

			incr numOfRes; 
		} else {
			set sel [atomselect top "resname $prevRes" ] 
			set temp [concat $prevRes $numOfRes];
			set prevRes $res;
			set numOfRes 1;
			lappend finalList $temp;
			set x [expr $x + 10]
		}
	}
	set temp [concat $prevRes $numOfRes];
	lappend finalList $temp;
	
	foreach item $finalList {
	puts $item;
	}
	
	close $fp;
	
}

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
proc Allignment {} { 
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
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set answer -1;

puts "Hello User, Choose your action with number from 1 to 6 "
puts "1. Load File";
puts "2. Select a residue";
puts "3. Save Selection";
puts "4. Analyze";
puts "5. Process Residues";
puts "6. Align Molecules";
puts "0. Exit";
gets stdin answer;
if {$answer == 1} {
	puts "Enter the path of the wanted file";
	gets stdin file;
	fileLoad $file ;
	

} elseif {$answer == 2} {
	#set load "1"
	#if {$loaded == $load} {
		puts "Please Enter the range of the wanted atoms"
		gets stdin low
		gets stdin high
		box_molecule $low $high $file;
		
	#} else {
	#	puts "You didn't load a proper file!"
	#}

} elseif {$answer == 3} {
	saveFile;

} elseif {$answer == 4} {
	analyze $file;
	

} elseif {$answer == 5} {
	process $file;
} elseif {$answer == 6} {
	Allignment;
}

puts "\n";