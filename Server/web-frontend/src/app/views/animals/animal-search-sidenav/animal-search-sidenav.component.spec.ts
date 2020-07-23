import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AnimalSearchSidenavComponent } from './animal-search-sidenav.component';

describe('AnimalSearchSidenavComponent', () => {
  let component: AnimalSearchSidenavComponent;
  let fixture: ComponentFixture<AnimalSearchSidenavComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AnimalSearchSidenavComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AnimalSearchSidenavComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
