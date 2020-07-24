import { HttpClient, HttpHandler } from '@angular/common/http';
import { CanActivate, Router } from '@angular/router';
import { TestBed } from '@angular/core/testing';
import { AuthGuardService } from './auth-guard.service';

describe('AuthGuardService', () => {
  let service: AuthGuardService;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        AuthGuardService, 
        HttpClient, 
        HttpHandler, 
        Router
      ]
    });

    service = TestBed.get(AuthGuardService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('canActivate', () => {
    it('should return false', () => {
      let temp = false;
      let response;

      spyOn(service, 'canActivate').and.returnValue(temp);

      response = service.canActivate();
      expect(response).toEqual(temp);
    });
  });
});
