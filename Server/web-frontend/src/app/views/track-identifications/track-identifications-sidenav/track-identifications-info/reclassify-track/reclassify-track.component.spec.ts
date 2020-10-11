import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReclassifyTrackComponent } from './reclassify-track.component';

describe('ReclassifyTrackComponent', () => {
  let component: ReclassifyTrackComponent;
  let fixture: ComponentFixture<ReclassifyTrackComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReclassifyTrackComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReclassifyTrackComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
