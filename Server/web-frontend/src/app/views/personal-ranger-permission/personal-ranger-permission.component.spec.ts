import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { PersonalRangerPermissionComponent } from './personal-ranger-permission.component';

describe('PersonalRangerPermissionComponent', () => {
  let component: PersonalRangerPermissionComponent;
  let fixture: ComponentFixture<PersonalRangerPermissionComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ PersonalRangerPermissionComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PersonalRangerPermissionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
