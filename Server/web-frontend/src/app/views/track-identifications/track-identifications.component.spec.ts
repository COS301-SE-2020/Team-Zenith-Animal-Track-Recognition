import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TrackIdentificationsComponent } from './track-identifications.component';

describe('TrackIdentificationsComponent', () => {
  let component: TrackIdentificationsComponent;
  let fixture: ComponentFixture<TrackIdentificationsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TrackIdentificationsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TrackIdentificationsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
