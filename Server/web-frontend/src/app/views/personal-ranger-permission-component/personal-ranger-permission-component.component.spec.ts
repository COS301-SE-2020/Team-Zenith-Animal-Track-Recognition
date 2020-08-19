import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { PersonalRangerPermissionComponentComponent } from './personal-ranger-permission-component.component';

describe('PersonalRangerPermissionComponentComponent', () => {
  let component: PersonalRangerPermissionComponentComponent;
  let fixture: ComponentFixture<PersonalRangerPermissionComponentComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ PersonalRangerPermissionComponentComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PersonalRangerPermissionComponentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
