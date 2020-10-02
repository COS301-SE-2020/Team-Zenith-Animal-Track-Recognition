import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalTrackInfoComponent } from './animal-track-info.component';

describe('AnimalTrackInfoComponent', () => {
  let component: AnimalTrackInfoComponent;
  let fixture: ComponentFixture<AnimalTrackInfoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalTrackInfoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalTrackInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
