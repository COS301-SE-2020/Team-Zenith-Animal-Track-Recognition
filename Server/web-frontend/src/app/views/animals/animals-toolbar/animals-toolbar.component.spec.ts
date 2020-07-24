import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalsToolbarComponent } from './animals-toolbar.component';

describe('AnimalsToolbarComponent', () => {
  let component: AnimalsToolbarComponent;
  let fixture: ComponentFixture<AnimalsToolbarComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalsToolbarComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalsToolbarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
