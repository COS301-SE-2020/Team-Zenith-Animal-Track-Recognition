import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { EMPTY } from 'rxjs';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { Router, ActivatedRoute } from '@angular/router';
import { RangerStatisticsService } from './../../services/ranger-statistics.service';

@Component({
	selector: 'app-overview',
	templateUrl: './overview.component.html',
	styleUrls: ['./overview.component.css'],
	providers: [RangerStatisticsService]
})
export class OverviewComponent implements OnInit {
	
	constructor(private router: Router, private rangerStatsService: RangerStatisticsService) { 
	}
  
	ngOnInit(): void {
		document.getElementById("overview-route").classList.add("activeRoute");
	}
	
	route(temp: string) {
		this.router.navigate([temp]);
	}
}
