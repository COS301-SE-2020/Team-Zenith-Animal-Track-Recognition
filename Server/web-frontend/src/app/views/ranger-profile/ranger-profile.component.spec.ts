import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RangerProfileComponent } from './ranger-profile.component';

describe('RangerProfileComponent', () => {
  let component: RangerProfileComponent;
  let fixture: ComponentFixture<RangerProfileComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RangerProfileComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RangerProfileComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
