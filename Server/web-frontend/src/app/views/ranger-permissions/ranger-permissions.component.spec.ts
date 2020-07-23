import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RangerPermissionsComponent } from './ranger-permissions.component';

describe('RangerPermissionsComponent', () => {
  let component: RangerPermissionsComponent;
  let fixture: ComponentFixture<RangerPermissionsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RangerPermissionsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RangerPermissionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
