import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalsGalleryComponent } from './animals-gallery.component';

describe('AnimalsGalleryComponent', () => {
  let component: AnimalsGalleryComponent;
  let fixture: ComponentFixture<AnimalsGalleryComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalsGalleryComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalsGalleryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
