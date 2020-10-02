import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TrackHeatmapOptionsComponent } from './track-heatmap-options.component';

describe('TrackHeatmapOptionsComponent', () => {
  let component: TrackHeatmapOptionsComponent;
  let fixture: ComponentFixture<TrackHeatmapOptionsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TrackHeatmapOptionsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TrackHeatmapOptionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
