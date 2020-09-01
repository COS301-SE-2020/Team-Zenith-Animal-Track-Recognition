import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AddImageComponent } from './add-image.component';

describe('AddImageComponent', () => {
  let component: AddImageComponent;
  let fixture: ComponentFixture<AddImageComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AddImageComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AddImageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
