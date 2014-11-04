#To-Do List

##High Priority
-	Completely document and comment existing code.

##Standard Priority
-	Separate frameCount and time clock. Is there a better way to do this? How can we scrub through the day? Export to a movie seems easy, but it'd be nice to have it in the program.
-	Graph building utilization
-	Write more efficient goToClass routine in the Student class
-	Make sure students arrive to campus with enough time to park
-	Building arrival and targeting should not be tied to a specific location. The Excel file should just say "Period 1: Class Name".
-	Remove hard-coded values for building locations and class times. Use separate tables instead.
-	Make table parsing more adaptive to other excel formats
-	Make tool to parse College's data into a format we can use, so we can quickly visualize other dates.

##Low Priority
-	Add path finding with A*
-	Add controls for student clustering (after path finding is implemented)
-	Document what it'll take to get this set up for another campus. (LCC, Skagit)
-	Restructure image layering (PGraphics buffer?)