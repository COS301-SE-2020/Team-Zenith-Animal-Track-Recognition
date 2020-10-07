import { Component, OnInit } from '@angular/core';
import { Track } from 'src/app/models/track';
import { TracksService } from './../../../../services/tracks.service';
import { TrackViewNavigationService } from './../../../../services/track-view-navigation.service';

@Component({
  selector: 'app-track-heatmap-options',
  templateUrl: './track-heatmap-options.component.html',
  styleUrls: ['./track-heatmap-options.component.css']
})
export class TrackHeatmapOptionsComponent implements OnInit {

	activeTrack: Track;
	heatmapTimeframes = {
		oneWeek: {
			frame1: "1 hr",
			frame2: "1 day",
			frame3: "3 days",
			frame4: "4 days",
			frame5: "6 days +"
		},
		oneMonth: {
			frame1: "1 hr",
			frame2: "6 days",
			frame3: "12 days",
			frame4: "18 days",
			frame5: "24 days +"			
		},
		sixMonths: {
			frame1: "1 hr",
			frame2: "1 month",
			frame3: "2 months",
			frame4: "4 months",
			frame5: "5 months +"
		},
		oneYear: {
			frame1: "1 hr",
			frame2: "2 months",
			frame3: "5 months",
			frame4: "7 months",
			frame5: "9 months +"
		}
	};
	heatmapActiveTimeframe = this.heatmapTimeframes.oneWeek;
	
	constructor(private tracksService: TracksService, private trackViewNavService: TrackViewNavigationService) {
		tracksService.activeTrack$.subscribe(
			track => {
				this.activeTrack = track;
			});
	}

	ngOnInit(): void {
	}
  
	backToTrackList() {
		this.trackViewNavService.toggleHeatmapSettings("inactive");
		if (this.activeTrack != null)
			this.trackViewNavService.changeTab("Track");
		else
			this.trackViewNavService.changeTab("Tracklist");
	}
	
	changeHeatmapColour(colour: string) {
		var heatmapColourLegend = document.getElementById("heatmap-intensity-colour-legend");
		switch(colour) {
			case "redGreen":
				heatmapColourLegend.style.backgroundImage = "linear-gradient(135deg, red, yellow, green)";
			break;
			case "redBlue":
				heatmapColourLegend.style.backgroundImage = "linear-gradient(135deg, red, purple, blue)";
			break;
			case "greenBlue":
				heatmapColourLegend.style.backgroundImage = "linear-gradient(135deg, yellow, green, blue)";
			break;
		}
		this.trackViewNavService.changeHeatmapColour(colour);
	}
	changeHeatmapRadius(event: any) {
		this.trackViewNavService.changeHeatmapRadius(event.value);
	}
	changeHeatmapTimeRange(timeRange: any) {
		switch(timeRange) {
			case "1 Week":
				this.heatmapActiveTimeframe = this.heatmapTimeframes.oneWeek;
			break;
			case "1 Month":
				this.heatmapActiveTimeframe = this.heatmapTimeframes.oneMonth;
			break;
			case "6 Months":
				this.heatmapActiveTimeframe = this.heatmapTimeframes.sixMonths;
			break;
			case "1 Year":
				this.heatmapActiveTimeframe = this.heatmapTimeframes.oneYear;
			break;
		}
		this.trackViewNavService.changeHeatmapTimeRange(timeRange);
	}
}
