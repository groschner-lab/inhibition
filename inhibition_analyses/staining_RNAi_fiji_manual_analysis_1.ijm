// By Birte Zuidinga, 2026

// Analysis 1
// Prompt for drawing regions in optic lobe stainings to make masks for later analyses.
// Only works well for images with 3 channels (1=GFP, 2=receptor, 3=brp) or 2 channels (1=brp, 2=receptor)

// Point to the input_data folder when prompted to run the code

close("*");

foldername=getDirectory("Choose a data folder");
list = getFileList(foldername);

for (f = 0; f < lengthOf(list); f++) {
	filename = list[f];
	if (endsWith(filename, ".lif")) {
//		Check if RoiSet file exists for this file, if so: skip file
		if (File.exists(foldername + substring(filename, 0, lastIndexOf(filename, ".")) + "_RoiSet.zip")) {
			print(filename);
			print("is analyzed already, skip file");
		}
		else {
	//		Open image and split channels, give different names
			run("Bio-Formats Importer", "open=" + foldername + "/" +  filename + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			filebase = File.nameWithoutExtension;
			directory = File.directory;
			getDimensions(width, height, channels, slices, frames);
			imageTitleOriginal = getTitle();
					
			startZ = round(slices / 2) - 1;
			stopZ = startZ + 2;
			
			run("Duplicate...", "ignore duplicate");
			imageDuplicate = getTitle();
			selectWindow(imageDuplicate);
			run("Z Project...", "start=" + startZ + " stop=" + stopZ + " projection=[Average Intensity]");
			imageTitleAvg = getTitle();
			
			selectWindow(imageTitleOriginal);
			run("Make Substack...", "channels=1-3 slices="+startZ+"-"+stopZ);

			selectWindow(imageTitleAvg);
			run("Split Channels");
		
			if (channels == 3) {
				GFPChannelWindow = "C1-" + imageTitleAvg;
				receptorChannelWindow = "C2-" + imageTitleAvg;
				brpChannelWindow = "C3-" + imageTitleAvg;
			}	else if (channels == 2) {
				GFPChannelWindow = "No";
				brpChannelWindow = "C1-" + imageTitleAvg;
				receptorChannelWindow = "C2-" + imageTitleAvg;
			}	
	
	//		Let user draw areas on Brp staining (in split channels)
			selectWindow(brpChannelWindow);
			run("Enhance Contrast", "saturated=0.35");
			setTool("polygon");
			run("ROI Manager...");
			roiManager("reset");
			
			neuropils = newArray("medulla", "lobula");
			for (i = 0; i < 2; i++) {
				neuropil = neuropils[i];
				waitForUser("Draw region " + neuropil, "Indicate the " + neuropil + " region by drawing a polygon and add to the ROI manager (t)");
				ROIs_n = roiManager("count");
				
				for (j = 0; j < ROIs_n; j++) {
					name = call("ij.plugin.frame.RoiManager.getName", j);
					if (!(endsWith(name, "medulla") || endsWith(name, "lobula"))) {
						roiManager("select", j);
						roiManager("rename", j + "_" + neuropil);
					}
				}
			}
			roiManager("save", directory + filebase + "_RoiSet.zip");
			ROIs_n = roiManager("count");
			}
		run("Close");
		close("*");
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



