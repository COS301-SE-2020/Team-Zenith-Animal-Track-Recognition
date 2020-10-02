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

	// Service message commands
	changeTab(tab: string) {
		this.trackSidenavSource.next(tab);
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
