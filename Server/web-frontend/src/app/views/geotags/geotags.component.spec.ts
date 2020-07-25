import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { GeotagsComponent } from './geotags.component';

describe('GeotagsComponent', () => {
  let component: GeotagsComponent;
  let fixture: ComponentFixture<GeotagsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ GeotagsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(GeotagsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
