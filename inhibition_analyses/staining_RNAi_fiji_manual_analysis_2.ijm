// By Birte Zuidinga, 2026

// Analysis 2
// Extract 2D ROIs of medulla and lobula based on manually drawn ROIs in analysis 1
// Only works well for images with 3 channels (1=GFP, 2=receptor, 3=brp) 

// Point to the input_data folder when prompted to run the code

close("*");

path=getDirectory("Choose a data folder");
analysis_folder = getFileList(path);

for (f = 0; f < lengthOf(analysis_folder); f++) {
	filename = analysis_folder[f];
	if (endsWith(filename, ".lif")) {
	//	Open image 
		run("Bio-Formats Importer", "open=" + path + "/" + filename + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		filebase = File.nameWithoutExtension;
		directory = File.directory;
		getDimensions(width, height, channels, slices, frames);
		imageTitleOriginal = getTitle();
		selectWindow(imageTitleOriginal);
		
		startZ = round(slices / 2) - 1;
		stopZ = startZ + 2;
		run("Make Substack...", "channels=1-3 slices="+startZ+"-"+stopZ);
		imageTitleOriginal = getTitle();
		selectWindow(imageTitleOriginal);
		savePath = directory + filebase;
		saveAs("tiff", savePath);
		
		run("Duplicate...", "ignore duplicate");
		imageDuplicate = getTitle();
		selectWindow(imageDuplicate);
		
	// Open RoiZip
		run("ROI Manager...");
		roiManager("reset");
		roipath = directory + filebase + "_RoiSet.zip";
		roiManager("Open", roipath);
		
		medulla_hull = 0;
		lobula_hull = 1; 
		
		roiManager("select", medulla_hull);
		run("Create Mask");
		mask_medulla = getTitle();
		selectWindow(mask_medulla);
		savePath = directory + filebase + "_mask_medulla";
		saveAs("tiff", savePath);
		
		roiManager("select", lobula_hull);
		run("Create Mask");
		mask_lobula = getTitle();
		selectWindow(mask_lobula);
		savePath = directory + filebase + "_mask_lobula";
		saveAs("tiff", savePath);
		
//		Get GFP mask medulla
		selectWindow(imageDuplicate);
		run("Split Channels");
		selectImage("C1-" + imageDuplicate);
		run("Duplicate...", "ignore duplicate");
		imageDuplicate2 = getTitle(); // for lobula later
		
		selectImage("C1-" + imageDuplicate);
		roiManager("Select", medulla_hull);
		run("Clear Outside", "stack");
		run("Make Binary", "background=Dark calculate create");
		GFP_mask_medulla = getTitle();
		savePath = directory + filebase + "_mask_GFP_medulla";
		saveAs("tiff", savePath);
		
		selectImage(imageDuplicate2);
		roiManager("Select", lobula_hull);
		run("Clear Outside", "stack");
		run("Make Binary", "background=Dark calculate create");
		GFP_mask_lobula = getTitle();
		savePath = directory + filebase + "_mask_GFP_lobula";
		saveAs("tiff", savePath);
		
		run("Close");
		close("*");
		}
		}
		