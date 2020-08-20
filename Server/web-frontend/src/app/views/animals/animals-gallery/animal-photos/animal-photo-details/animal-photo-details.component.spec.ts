import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalPhotoDetailsComponent } from './animal-photo-details.component';

describe('AnimalPhotoDetailsComponent', () => {
  let component: AnimalPhotoDetailsComponent;
  let fixture: ComponentFixture<AnimalPhotoDetailsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalPhotoDetailsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalPhotoDetailsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
