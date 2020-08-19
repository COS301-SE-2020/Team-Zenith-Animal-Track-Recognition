import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TrackIdentificationsMapComponent } from './track-identifications-map.component';

describe('TrackIdentificationsMapComponent', () => {
  let component: TrackIdentificationsMapComponent;
  let fixture: ComponentFixture<TrackIdentificationsMapComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TrackIdentificationsMapComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TrackIdentificationsMapComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
