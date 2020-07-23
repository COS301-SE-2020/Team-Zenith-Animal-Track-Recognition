import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EditRangerInfoComponent } from './edit-ranger-info.component';

describe('EditRangerInfoComponent', () => {
  let component: EditRangerInfoComponent;
  let fixture: ComponentFixture<EditRangerInfoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EditRangerInfoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EditRangerInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
