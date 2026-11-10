// By Birte Zuidinga, 2026

// Analysis 3
// Prompt for manually drawing GFP masks for medulla and lobula based on the automatic mask.
// This is to exlcude pixels of GFP staining that do not belong to T4 and T5. Drawing can be imprecise, just include all pixels that need
// to be in the mask. Since later the manual & automatic mask are used to create the 'true' mask. 
// Uses data from analysis 2
// Only works well for images with 3 channels (1=GFP, 2=receptor, 3=brp) 

// Point to the input_data folder when prompted to run the code


close("*");

foldername = getDirectory("Choose a data folder");
list = getFileList(foldername);

for (f = 0; f < lengthOf(list); f++) {
	filename = list[f];
	if (endsWith(filename, "mask_GFP_medulla.tif")){
//		Open image and split channels, give different names
		run("Bio-Formats Importer", "open=" + foldername + "/" +  filename + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		filebase = File.nameWithoutExtension;
		directory = File.directory;
		if (!File.exists(directory + filebase + "_manual_mask_medulla_GFP.tif")){
			imageTitleOriginal = getTitle();
			setSlice(2);
	
			run("Colors...", "foreground=red background=black selection=red");
			setTool("polygon");
			run("ROI Manager...");
			roiManager("reset");
			
			waitForUser("Draw region medulla GFP", "Indicate the T4T5 GFP region in medulla by drawing a polygon and add to the ROI manager (t)");
			roiManager("select", 0);
			run("Create Mask");
			mask_GFP_medulla = getTitle();
			selectWindow(mask_GFP_medulla);
			savePath = directory + filebase + "_manual_mask_medulla_GFP";
			saveAs("tiff", savePath);
			
			roiManager("save", directory + filebase + "_RoiSet_GFP_lobula_manual.zip");
			
			run("Close");
			close("*");
			}
		}
	if(endsWith(filename, "mask_GFP_lobula.tif")) {
//		Open image and split channels, give different names
		run("Bio-Formats Importer", "open=" + foldername + "/" +  filename + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		filebase = File.nameWithoutExtension;
		directory = File.directory;
		if (!File.exists(directory + filebase + "_manual_mask_lobula_GFP.tif")){
			imageTitleOriginal = getTitle();
			setSlice(2);
	
			setTool("polygon");
			run("ROI Manager...");
			roiManager("reset");
			
			waitForUser("Draw region lobula GFP", "Indicate the T4T5 GFP region in lobula by drawing a polygon and add to the ROI manager (t)");
			roiManager("select", 0);
			run("Create Mask");
			mask_GFP_lobula = getTitle();
			selectWindow(mask_GFP_lobula);
			savePath = directory + filebase + "_manual_mask_lobula_GFP";
			saveAs("tiff", savePath);
			
			roiManager("save", directory + filebase + "_RoiSet_GFP_lobula_manual.zip");
			
			run("Close");
			close("*");
			}
			}
	else {print(filename);
	}
}


function selectCorrectWindow(m, channels_n) { 
		// select the correct window based on m looping through channels and number of channels
	if (m == 0 && channels_n == 2) {
			selectWindow(brpChannelWindow);
			channel = "brp";
		} else if (m == 1 && channels_n == 2) {
			selectWindow(receptorChannelWindow);
			channel = "receptor";
		} else if (m == 0 && channels_n == 3) {
			selectWindow(brpChannelWindow);
			channel = "brp";
		} else if (m == 1 && channels_n == 3) {
			selectWindow(receptorChannelWindow);
			channel = "receptor";
		} else if (m == 2 && channels_n == 3) {
			selectWindow(GFPChannelWindow);
			channel = "GFP";
		}
	return channel;
}



