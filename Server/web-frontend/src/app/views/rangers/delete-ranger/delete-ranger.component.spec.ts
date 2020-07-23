import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DeleteRangerComponent } from './delete-ranger.component';

describe('DeleteRangerComponent', () => {
  let component: DeleteRangerComponent;
  let fixture: ComponentFixture<DeleteRangerComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DeleteRangerComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DeleteRangerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
