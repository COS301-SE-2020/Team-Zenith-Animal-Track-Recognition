import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';

@Injectable()
export class TrackViewNavigationService {

	constructor() { }
	
	//Determines which tab is currently being viewed in the Track sidenav
	private trackSidenavSource = new Subject<string>();
	trackSidenavTab$ = this.trackSidenavSource.asObservable();
	
	//Determines which track is currently being zoomed in on
	private trackMapZoomSource = new Subject<string>();
	trackMapZoom$ = this.trackMapZoomSource.asObservable();
	
	//Determines whether heatmap is currently active
	private trackHeatmapSource = new Subject<string>();
	trackHeatmap$ = this.trackHeatmapSource.asObservable();
	
	//Determines whether heatmap settings are available
	private trackHeatmapSettingsSource = new Subject<string>();
	trackHeatmapSettings$ = this.trackHeatmapSettingsSource.asObservable();
	
	//Determines which heatmap colour is set
	private trackHeatmapColourSource = new Subject<string>();
	trackHeatmapColour$ = this.trackHeatmapColourSource.asObservable();
	
	//Determines the radius of the heatmap around each track
	private trackHeatmapRadiusSource = new Subject<number>();
	trackHeatmapRadius$ = this.trackHeatmapRadiusSource.asObservable();

	changeTab(tab: string) {
		this.trackSidenavSource.next(tab);
	}
	
	changeHeatmapColour(colour: string) {
		this.trackHeatmapColourSource.next(colour);
	}
	
	changeHeatmapRadius(radius: number) {
		this.trackHeatmapRadiusSource.next(radius);
	}
	
	toggleHeatmap(status: string) {
		this.trackHeatmapSource.next(status);
	}
	
	toggleHeatmapSettings(status: string) {
		this.trackHeatmapSettingsSource.next(status);
	}
	
	zoomOnTrack(coords: string) {
		this.trackMapZoomSource.next(coords);
	}
}
