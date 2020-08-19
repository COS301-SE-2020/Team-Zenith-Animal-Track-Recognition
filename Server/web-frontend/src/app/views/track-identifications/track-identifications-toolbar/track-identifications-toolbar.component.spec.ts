import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TrackIdentificationsToolbarComponent } from './track-identifications-toolbar.component';

describe('TrackIdentificationsToolbarComponent', () => {
  let component: TrackIdentificationsToolbarComponent;
  let fixture: ComponentFixture<TrackIdentificationsToolbarComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TrackIdentificationsToolbarComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TrackIdentificationsToolbarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
