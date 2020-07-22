import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RangerSearchSidenavCompComponent } from './ranger-search-sidenav-comp.component';

describe('RangerSearchSidenavCompComponent', () => {
  let component: RangerSearchSidenavCompComponent;
  let fixture: ComponentFixture<RangerSearchSidenavCompComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ RangerSearchSidenavCompComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RangerSearchSidenavCompComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
