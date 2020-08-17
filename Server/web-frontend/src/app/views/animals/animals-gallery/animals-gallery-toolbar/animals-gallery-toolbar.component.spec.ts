import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalsGalleryToolbarComponent } from './animals-gallery-toolbar.component';

describe('AnimalsGalleryToolbarComponent', () => {
  let component: AnimalsGalleryToolbarComponent;
  let fixture: ComponentFixture<AnimalsGalleryToolbarComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalsGalleryToolbarComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalsGalleryToolbarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
