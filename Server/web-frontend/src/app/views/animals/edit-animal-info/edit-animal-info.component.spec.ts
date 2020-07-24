import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EditAnimalInfoComponent } from './edit-animal-info.component';

describe('EditAnimalInfoComponent', () => {
  let component: EditAnimalInfoComponent;
  let fixture: ComponentFixture<EditAnimalInfoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EditAnimalInfoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EditAnimalInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
