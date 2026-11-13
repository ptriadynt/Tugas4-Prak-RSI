import {
  UserRepository,
  type CreateUserInput,
} from '../repositories/userRepository.ts';


export class UserService {
  private userRepository: UserRepository;

  constructor(userRepository: UserRepository = new UserRepository()) {
    this.userRepository = userRepository;
  }

  async getAllUsers() {
    return await this.userRepository.findAll();
  }

  async createUser(input: CreateUserInput) {
    const existingUser = await this.userRepository.findByEmail(input.email);

    if (existingUser) {
      throw new Error('EMAIL_ALREADY_EXISTS');
    }

    return await this.userRepository.create(input);
  }

  async updateRole(id: number, role: 'admin' | 'owner' | 'customer') {
    const updated = await this.userRepository.updateRole(id, role);
    if (!updated) {
      throw new Error('USER_NOT_FOUND');
    }
    return updated;
  }
}