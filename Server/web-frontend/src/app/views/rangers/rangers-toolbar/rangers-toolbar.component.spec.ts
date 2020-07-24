import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RangersToolbarComponent } from './rangers-toolbar.component';

describe('RangersToolbarComponent', () => {
  let component: RangersToolbarComponent;
  let fixture: ComponentFixture<RangersToolbarComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RangersToolbarComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RangersToolbarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
