import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TrackIdentificationsInfoComponent } from './track-identifications-info.component';

describe('TrackIdentificationsInfoComponent', () => {
  let component: TrackIdentificationsInfoComponent;
  let fixture: ComponentFixture<TrackIdentificationsInfoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TrackIdentificationsInfoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TrackIdentificationsInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
