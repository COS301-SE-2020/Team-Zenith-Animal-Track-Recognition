import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RangerProfileCardComponent } from './ranger-profile-card.component';

describe('RangerProfileCardComponent', () => {
  let component: RangerProfileCardComponent;
  let fixture: ComponentFixture<RangerProfileCardComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RangerProfileCardComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RangerProfileCardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
