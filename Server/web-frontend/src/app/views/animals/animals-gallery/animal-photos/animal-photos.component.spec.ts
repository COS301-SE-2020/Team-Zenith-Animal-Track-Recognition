import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalPhotosComponent } from './animal-photos.component';

describe('AnimalPhotosComponent', () => {
  let component: AnimalPhotosComponent;
  let fixture: ComponentFixture<AnimalPhotosComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalPhotosComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalPhotosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
