import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalsGalleryCardComponent } from './animals-gallery-card.component';

describe('AnimalsGalleryCardComponent', () => {
  let component: AnimalsGalleryCardComponent;
  let fixture: ComponentFixture<AnimalsGalleryCardComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalsGalleryCardComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalsGalleryCardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
