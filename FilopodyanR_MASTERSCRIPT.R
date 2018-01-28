### FilopodyanR_MASTERSCRIPT

# This script calls various FilopodyanR modules and integrates output

#-------------------------------------------------------------------------------
# Clean current workspace. WARNING: deletes everything in current workspace

rm(list = ls())
ls()

#-------------------------------------------------------------------------------
# Setting Working Directory locations:

# DATA:

# Where is your data located?

dir <- "/Users/mlouveaux/Documents/Postdoc/Logistique/Conferences_Missions/Szeged_NEUBIAS_2018/TS7/Vasja/Vasja/Datasets"

folder.names <- c(
    folder.name1 = paste0(dir, "/4a_Manually-curated-tables"),   # <--- Set folder locations of intput data tables
    folder.name2 = paste0(dir, "/4a_Big-ctrl-dataset/batch_preprocessed"),
    folder.name3 = paste0(dir, "/4a_Big-ctrl-dataset/CAD_Boundertables")
    )


n.fold <- length(folder.names)
cat("Number of folders to analyse :", n.fold)
folder.names[]

# What do you want to call your datasets (e.g. "Ctrl" and "Drug1")

dataset.names <- c(
	dataset1 = "Manual"    # <---- Insert dataset names here.
	, dataset2 = "Batch"   # <---- Insert dataset names here.
	, dataset3 = "Perso"
	)

# Where to save results?
Loc.save <- "/Users/Lab/Documents/Postdoc/2018_Szeged/TS7_Filopodyan/Materials/Datasets/4a_RESULTS"			# <---- Set saving directory here

# SCRIPTS:

Loc.Modules <- c("/Users/Lab/Documents/Postdoc/2018_Szeged/TS7_Filopodyan/Materials/Scripts_FilopodyanR")
scripts <- c("FilopodyanR Module 1.R", "FilopodyanR Module 2.R")

# Run Module 3 to compare filopodium properties?
compare.phenotypes = TRUE
reference.dataset = dataset.names[1]

plot.boxCDFs  = TRUE
plot.timecourse = FALSE
plot.summary = TRUE
save.summary = TRUE


# Test working directories:

setwd(Loc.save)
setwd(folder.names[1])
setwd(Loc.Modules)

#-------------------------------------------------------------------------------
# Objects to keep between script runs when cleaning workspace:

keep <- c("Loc.Modules", "folder.names", "dataset.names", "n.fold", "scripts", "metalist", "objectnames", "keep", "iter", "i", "FilopodyanR", "compare.phenotypes", "reference.dataset", "Loc.save")  


#-------------------------------------------------------------------------------
# FilopodyanR ("run suite of FilopodyanR modules") function calls all defined scripts, executes one after another on one defined dataset

FilopodyanR <- function() {
	
	for (i in seq_along(scripts)) {
		setwd(Loc.Modules);
		source(scripts[i], echo = FALSE);
		ls()
	}		
}


#-------------------------------------------------------------------------------
# Loop FilopodyanR over all defined folders on all defined scripts.

metalist    <- list()
objectnames <- list()

for (iter in seq_along(folder.names)) {
	rm(list = setdiff(ls(), keep))

	# RUN FILOPODYAN MODULES AS A FUNCTION
	FilopodyanR()
	
	# Save variables before iteration on next folder:
	objectnames[[iter]] <- setdiff(ls(), keep)
	dataset <- lapply(objectnames[[iter]], get)
	names(dataset) <- objectnames[[iter]]
	metalist[[iter]] <- dataset
	rm(dataset)
	rm(list = setdiff(ls(), keep))	
}

names(metalist) <- dataset.names
names(metalist)

ls()


 if(compare.phenotypes == TRUE) {
	 setwd(Loc.Modules)
	 source("FilopodyanR Module 3.R", echo = FALSE)
 }
 graphics.off()

setwd(Loc.save); save.image(file = "LastWorkspace_Phenotype.Rdata")
