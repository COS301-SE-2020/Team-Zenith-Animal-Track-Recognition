import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AddAnimalComponent } from './add-animal.component';

describe('AddAnimalComponent', () => {
  let component: AddAnimalComponent;
  let fixture: ComponentFixture<AddAnimalComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AddAnimalComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AddAnimalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
