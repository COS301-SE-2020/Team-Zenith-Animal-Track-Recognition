import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AddRangerComponent } from './add-ranger.component';

describe('AddRangerComponent', () => {
  let component: AddRangerComponent;
  let fixture: ComponentFixture<AddRangerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AddRangerComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AddRangerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
