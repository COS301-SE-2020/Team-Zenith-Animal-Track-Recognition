import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TrackIdentificationsSidenavComponent } from './track-identifications-sidenav.component';

describe('TrackIdentificationsSidenavComponent', () => {
  let component: TrackIdentificationsSidenavComponent;
  let fixture: ComponentFixture<TrackIdentificationsSidenavComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TrackIdentificationsSidenavComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TrackIdentificationsSidenavComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
