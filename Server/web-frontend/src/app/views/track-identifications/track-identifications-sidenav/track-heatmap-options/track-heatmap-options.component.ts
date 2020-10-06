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
		this.trackViewNavService.changeHeatmapTimeRange(timeRange);
	}
}
